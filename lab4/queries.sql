Select * from Person where PersonID = 
    ANY(select PersonID from MarkSet where MarkID = ANY(
                Select MarkID from Mark Where Type = ANY(
                        array['Сосоеди', 'Коллеги']
                        )
                )
        )

select * from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID from Mark where Type = 'Друзья'
    )
);


select * from ( select * from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID from Mark where Type = 'Друзья'
        )
    )
) as foo where PersonID = ANY(
        select PersonID from Phone where (
            local = '8' and prefix = '911' 
            )
        );

select * from Person where not (PersonID = ANY(
    select PersonID from MarkSet
    )
);


select * from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Сосоеди'
    )
    INTERSECT
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Коллеги'
    )
);

select * from Person ORDER BY DateOfBirth DESC;


select extract(month from TIMESTAMP DateOfBirth) from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Сосоеди'
    )
)
Except 
select extract(month from TIMESTAMP DateOfBirth) from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Самья'
    )
);

OR

select extract ( month from any(select DateOfBirth from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Сосоеди'
    )
)))
Except 
select extract ( month from any(select DateOfBirth from Person where PersonID = ANY(
    select PersonID from MarkSet where MarkID = ANY(
        select MarkID where Type = 'Самья'
    )
)));


select * from Mark ORDER BY (
    select count(*) from Mark where MarkID = any(
        select MarkID from MarkSet
        )
    ) ASC;


select extract( month from DateOfBirth) from Person Where PersonID = 
ANY(select PersonID as tmp from Person where 
   (select MarkID from MarkSet where PersonID = tmp) = ALL(
       select MarkID from Mark
   )
);
   













































