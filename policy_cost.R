# plot graph of scenarios compared to the reference scenario
# do a bar plot of AP health costs, consumption loss and the net

library('ggthemes')
library('moinput')
library('remind')
library('luscale')
library('ggplot2')
library('dplyr')
library('ggpubr')
library('cowplot')
library("RColorBrewer")
library('gridExtra')

setConfig(regionmapping = 'regionmappingREMIND.csv')

do_iso     <- TRUE
do_regions <- FALSE
setwd(wd_dir)
dir_root           <- paste0(getwd()    ,'/mnt/FASST_IDL_PACK/')              # main folder

dir_plot_out       <- paste0(getwd(),  '/plots/')                              # output
dir_ancil          <- paste0(dir_root,  'ANCILLARY/')                         # ancillary data ()
dir_spat_map       <- paste0(dir_ancil, 'SPATIAL_MAPPING/')                   # Spatial mapping
mapping_REMIND     <- paste0(dir_spat_map,   'regionmappingREMIND.csv') 
dir_outtab         <- paste0(dir_root,  'OUTPUT/TABLES')                      # output (tables)
dir_out            <- paste0(getwd(),'/mnt/FASST_IDL_PACK/OUTPUT/NCDF')
dir_cost            <- paste0(getwd(),'/mnt/FASST_IDL_PACK/OUTPUT/cost')
policy_cost_iso_write_out <- 0

for(ap_scen in c('trend','stringent','FE')){
  
  if(ap_scen == 'trend') { scenarios <-  c("SSP2_SSP2-Ref_SSP2_IIASA_aneris_downscaling_",                    
                                           "SSP2_SSP2-INDC_SSP2_IIASA_aneris_downscaling_",                  
                                           "SSP2_SSP2-INDC_coal_exit_SSP2_IIASA_aneris_downscaling_",        
                                           "SSP2_SSP2-26_SSP2_IIASA_aneris_downscaling_"             )
  
  remind_output <- paste0(getwd()    ,'/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/standart')
  scenario_ref        <- "SSP2_SSP2-Ref_SSP2_IIASA_aneris_downscaling"
  scenario_folders <- c("C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/standart/SSP2-Ref_2018-07-26_14.10.58/",
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/standart/SSP2-INDC_2018-07-26_11.38.53/",          
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/standart/SSP2-INDC_coal_exit_2018-08-13_16.41.29/",
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/standart/SSP2-26_2018-07-26_14.13.39/")}
  
  if(ap_scen == 'stringent') { scenarios <-  c("SSP1_SSP2-Ref_AP_SSP1_SSP2_IIASA_aneris_downscaling_",            
                                               "SSP1_SSP2-INDC_AP_SSP1_SSP2_IIASA_aneris_downscaling_",         
                                               "SSP1_SSP2-INDC_AP_SSP1_coal_exit_SSP2_IIASA_aneris_downscaling_",
                                               "SSP1_SSP2-26_AP_SSP1_SSP2_IIASA_aneris_downscaling_"      )
  remind_output <- paste0(getwd()    ,'/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/AP1')
  scenario_ref        <- "SSP1_SSP2-Ref_AP_SSP1_SSP2_IIASA_aneris_downscaling"
  scenario_folders <- c("C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/AP1/SSP2-Ref_AP_SSP1_2018-08-10_06.28.50/",            
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/AP1/SSP2-INDC_AP_SSP1_2018-08-09_23.34.56/",          
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/AP1/SSP2-INDC_AP_SSP1_coal_exit_2018-08-13_16.45.41/",
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/AP1/SSP2-26_AP_SSP1_2018-08-10_06.31.26/")}
  
  if(ap_scen == 'FE') { scenarios <-  c("FLE_SSP2-Ref_FE_SSP2_IIASA_aneris_downscaling_",                  
                                        "FLE_SSP2-INDC_FE_SSP2_IIASA_aneris_downscaling_",                
                                        "FLE_SSP2-INDC_FE_coal_exit_SSP2_IIASA_aneris_downscaling_",      
                                        "FLE_SSP2-26_FE_SSP2_IIASA_aneris_downscaling_") 
  remind_output <- paste0(getwd()    ,'/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/FE')
  scenario_ref        <- "FLE_SSP2-Ref_FE_SSP2_IIASA_aneris_downscaling"
  scenario_folders <- c("C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/FE/SSP2-Ref_FE_2018-08-07_20.29.12/",           
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/FE/SSP2-INDC_FE_2018-08-07_17.53.59/",          
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/FE/SSP2-INDC_FE_coal_exit_2018-08-13_16.34.24/",
                        "C:/Users/rauner/Documents/PIK/fasstr_sebastian/mnt/FASST_IDL_PACK/REMIND_OUTPUT/new_paper/FE/SSP2-26_FE_2018-08-07_20.31.55/")}
  
  
  
  
  
  #chose the ref scenario, show warning if no reference is found
  if(TRUE %in% grepl('Ref', scenario_folders)){ scenario_folder_ref <- grep('Ref', scenario_folders, value = TRUE)} else (
    
    if(u_verbose) cat("no Ref scenario found, supply manually\n")
  )
  
  scens = c(
    "FLE_SSP2-26_FE_SSP2_IIASA_aneris_downscaling_",                  
    "FLE_SSP2-INDC_FE_coal_exit_SSP2_IIASA_aneris_downscaling_",     
    "FLE_SSP2-INDC_FE_SSP2_IIASA_aneris_downscaling_",               
    "FLE_SSP2-Ref_FE_SSP2_IIASA_aneris_downscaling",              
    "SSP1_SSP2-26_AP_SSP1_SSP2_IIASA_aneris_downscaling_",           
    "SSP1_SSP2-INDC_AP_SSP1_coal_exit_SSP2_IIASA_aneris_downscaling_",
    "SSP1_SSP2-INDC_AP_SSP1_SSP2_IIASA_aneris_downscaling_",        
    "SSP1_SSP2-Ref_AP_SSP1_SSP2_IIASA_aneris_downscaling",           
    "SSP2_SSP2-26_SSP2_IIASA_aneris_downscaling_",                    
    "SSP2_SSP2-INDC_coal_exit_SSP2_IIASA_aneris_downscaling_",        
    "SSP2_SSP2-INDC_SSP2_IIASA_aneris_downscaling_",                  
    "SSP2_SSP2-Ref_SSP2_IIASA_aneris_downscaling_"  ) 
  
  scens_short = 
    c("SSP2-Ref",
      "SSP2-INDC",
      "SSP2-INDC_coal_exit",
      "SSP2-26",
      "Reference_stringent",
      "INDC_stringent",
      "INDC coal exit_stringent",
      "2°C_stringent",
      "Reference_FE",
      "INDC_FE",
      "INDC coal exit_FE",
      "2°C_FE")
  
  scens <- rev(scens)
  #loop here over the scenarios which are not REF
  #make sure the scenario and scenario folder matches
  i <-1
  
  for(scenario in scenarios){
    
    
    scenario_folder      <- scenario_folders[i]
    scenario_folder_ref  <- scenario_folders[1]
    
    
    
    
    remind_emiss       <- paste0(scenario_folder,     'fulldata.gdx')
    remind_emiss_ref   <- paste0(scenario_folder_ref, 'fulldata.gdx')
    
    remind_config      <- paste0(scenario_folder,     'config.Rdata')
    remind_config_ref  <- paste0(scenario_folder_ref, 'config.Rdata')
    
    
    # calculate the policy cost and break them down to iso level
    
    ## read and calculate proxies and mappings necessary for the region to iso disaggregation
    gdp    <- calcOutput("GDPppp",     years=u_year, aggregate = F) 
    # read the region mappings
    regionmapping_REMIND      <- read.csv2(mapping_REMIND,check.names=FALSE)
    
    
    load(remind_config)
    ssp_scenario_remind_emiss <- cfg$gms$c_LU_emi_scen
    load(remind_config_ref)
    ssp_scenario_remind_emiss_ref <- cfg$gms$c_LU_emi_scen
    
    if(ssp_scenario_remind_emiss != ssp_scenario_remind_emiss_ref){cat('you compare two different SSP scenarios!\n the ref GDP is chosen for the iso downscaling')}
    
    
    
    gdp_ssp_remind_emiss_ref <- gdp[,,paste0('gdp_',ssp_scenario_remind_emiss_ref)]
    
    # rename variable name to value (required by speed_aggregate)
    dimnames(gdp_ssp_remind_emiss_ref)$variable <- 'value'
    
    
    # use Policy Cost|Consumption + Current Account Loss (billion US$2005/yr)
    policy_cost     <- reportPolicyCosts(remind_emiss, remind_emiss_ref)
    
    '%ni%' <- Negate('%in%')
    
    #delete GLO
    policy_cost <- policy_cost[dimnames(policy_cost)$all_regi %ni% 'GLO',dimnames(policy_cost)$ttot %in% paste0('y',u_year),]
    
    if(do_iso){
      policy_cost_iso <- speed_aggregate(policy_cost, rel=regionmapping_REMIND, weight=gdp_ssp_remind_emiss_ref,
                                         from = 'RegionCode', to = 'CountryCode', partrel = TRUE)}
    if(do_regions){
      policy_cost_iso <- policy_cost
    }
    
    policy_cost_iso_scenario <- as.quitte(policy_cost_iso)
    
    scen <- plyr::mapvalues(scenario,     from = scens, to = scens_short)
    policy_cost_iso_scenario$scenario <- scen
    policy_cost_iso_write_out <- rbind(policy_cost_iso_write_out,policy_cost_iso_scenario)
    
    #write the policy cost for the lca script
    # read the results csvs of deaths and AP healths costs for the 
    i=i+1
  }
  colnames(policy_cost_iso_write_out) <- c('x','scenario', 'region','y','z','period','mitigation_value','mitigation_variable')
  policy_cost_iso_write_out <- policy_cost_iso_write_out %>% select('scenario','period', 'region','mitigation_variable','mitigation_value')
  write.csv(policy_cost_iso_write_out[-1,],file=paste(dir_cost,'/policy_cost_iso_',ap_scen,'.csv',sep=''))
  
}