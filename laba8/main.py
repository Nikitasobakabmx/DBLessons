from threading import Thread
import psycopg2
from os import startfile
import pandas as pd
from pandas.io.json import json_normalize
import sqlalchemy as sq
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Column, Integer, String, Date

# dotnet
import clr

clr.AddReference('System.Windows.Forms')
clr.AddReference('System.Drawing')
clr.AddReference('System.Data')
# clr.AddReference('C:\Users\Nikittossii\Documents\DBLessons\laba8\packages')
# clr.AddReference('System.ComponentModel.IComponent')

from System.Windows.Forms import Form, Application, DataGridView, Label 
from System.Drawing import Size
from System.Data import DataTable
# from System.ComponentModel.IComponent import NpgsqlConnection

def init_ui(name):
    form = Form()
    form.Text = name
    form.ClientSize = Size(1000, 500)
    form.MinimumSize = Size(500, 200)
    return form

def data_grid(query):
    startfile("C://Users//Nikittossii//source//repos//laba8//laba8//bin//x64//Release//laba8.exe")
    # form = init_ui("datagrid")
    
    # pg_con = psycopg2.connect(
    #     dbname="dblessons",
    #     user="nikittossii",
    #     password="111261",
    #     host="127.0.0.1",
    #     port="5432"
    # )

    # cur = pg_con.cursor()
    # # mb dataframe == datatable
    # table = pd.read_sql_query(query, pg_con)
    # text_box = Label()
    # text_box.Text = table.to_string()
    # text_box.ClientSize = Size(950, 450)
    # form.Controls.Add(text_box)
    # # table.to_sql('person', con=pg_con)
    # Application.Run(form)

    # cur.close()
    # pg_con.close()

def sql_comand(query):
    form = init_ui("sql comand")

    pg_con = psycopg2.connect(
        dbname="dblessons",
        user="nikittossii",
        password="111261",
        host="127.0.0.1",
        port="5432"
    )

    cur = pg_con.cursor()
    
    dg = DataGridView()
    dg.Columns.Add("column0", "PersonID")
    dg.Columns.Add("column1", "Name")
    dg.Columns.Add("column2", "Surname")
    dg.Columns.Add("column3", "Patronumic")
    dg.Columns.Add("column4", "Description")
    dg.Columns.Add("column5", "DateOfBith")
    dg.Columns.Add("column6", "Photo")

    text_box = Label()
    table = []
    cur.execute(query)
    for row in cur: #cur.fetchone()
        dg.Rows.Add(str(row[0]),
                str(row[1]), 
                str(row[2]),
                str(row[3]), 
                str(row[4]), 
                str(row[5]), 
                str(row[5]))
    dg.ClientSize = Size(950, 450)

    cur.close()
    pg_con.close()

    form.Controls.Add(dg)
    Application.Run(form)

# ORM
def orm():
    form = init_ui("orm")

    engine = sq.create_engine("postgresql+pg8000://nikittossii:111261@localhost:5432/dblessons")
    # connection = engine.connect()
    Session = sessionmaker(bind=engine)
    session = Session()
    table = []
    for instance in session.query(Person):
        table.append(str(instance))
    text_box = Label()
    text_box.Text = "\n".join(table)
    text_box.ClientSize = Size(950, 450)

    # end of func
    form.Controls.Add(text_box)
    Application.Run(form)

Base = declarative_base()

class Person(Base):
    __tablename__  = 'person' #!!!!!! IN LOW CASE

    personid = Column(Integer,primary_key=True)
    name = Column(String(30))
    surname = Column(String(30))
    patronumic = Column(String(30))
    description = Column(String(150))
    dateofbirth  = Column(Date)
    photo = Column(String(150))
    # autocast str
    def __repr__(self):
        return "%s    %s    %s" % (self.personid, self.name, self.surname)
# END ORM

if __name__ == "__main__":
    query = 'SELECT * FROM Person'
    threads = [Thread(target=data_grid, args=(query, )),
               Thread(target=sql_comand, args=(query, )),
               Thread(target=orm)]
    for i in threads:
        i.start()
    for i in threads:
        i.join()