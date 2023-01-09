let func = 
    (table as table) => 
        let
            Source = table,

            //a table with columns {Column,Min,Max,Average,StandardDeviation,Count,NullCount,DistinctCount}
            initial = Table.Profile(Source),

            //the additional functions we want to apply to each column as {function, Column suffix}
            funcs = {
                        {(c as text) => Table.Group(Source,{c},{{"Frequency",Table.RowCount}}), "Frequency"},
                        {(c as text) => Table.Group(Source,{c},{{"Profile",Table.Profile}})  , "ItemProfiles"},
                        {(c as text) => try List.Count(List.Select(Table.Column(Source,c),each _>1000)) otherwise null, "GreaterThan1000"}
                    },


            Accumulate = List.Accumulate(
                funcs,
                initial,
                (a,b) => Table.AddColumn(
                    a, //the accumulated table
                    b{1},//the name of the new column for your function
                    each b{0}([Column]) //pass the column name into the function
                )
            )
        in
            Accumulate,
documentation = [
Documentation.Name =  "fnCustomProfiling ",
Documentation.Description = " Calculates column profiling using custom functions. ",
Documentation.LongDescription = " Demonstrates how to use List.Accumulate to expand the results of Table.Profile to include additional business-logic. ",
Documentation.Category = " Profiling ",
Documentation.Source = " www.flexyourdata.com  ",
Documentation.Version = " 1.0 ",
Documentation.Author = " Owen Price "]
 in  
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))