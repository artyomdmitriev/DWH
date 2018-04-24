/*
 This is the first script that deploys the DWH on the clean DB.
 It creates users and objects (tables, sequences, etc.) for them.
 To create packages, the following scripts must be executed from related users:
  * bl_cl/deploy_script_bl_cl
  * bl_cl_dm/deploy_script_bl_cl_dm
*/

@"D:\Artsemi_Dzmitryieu\Module4\Shared_Folder\BI_Lab_winter-spring_2018\_0. DWH\Projects\Artsemi_Dzmitryieu\dwso\sa_src\ddl_script_sa_src.sql"
@"D:\Artsemi_Dzmitryieu\Module4\Shared_Folder\BI_Lab_winter-spring_2018\_0. DWH\Projects\Artsemi_Dzmitryieu\dwso\bl_3nf\ddl_script_bl_3nf.sql"
@"D:\Artsemi_Dzmitryieu\Module4\Shared_Folder\BI_Lab_winter-spring_2018\_0. DWH\Projects\Artsemi_Dzmitryieu\dwso\bl_cl\ddl_script_bl_cl.sql"
@"D:\Artsemi_Dzmitryieu\Module4\Shared_Folder\BI_Lab_winter-spring_2018\_0. DWH\Projects\Artsemi_Dzmitryieu\dwso\bl_dm\ddl_script_bl_dm.sql"
@"D:\Artsemi_Dzmitryieu\Module4\Shared_Folder\BI_Lab_winter-spring_2018\_0. DWH\Projects\Artsemi_Dzmitryieu\dwso\bl_cl_dm\ddl_script_bl_cl_dm.sql"