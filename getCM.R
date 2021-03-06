getCM <- function(model, prob_preds, real_labels, id_observations, case, control, type_opt) {
  
  if (is.numeric(type_opt)) {
    
    custom_pred <- factor(
      x = ifelse(prob_preds[[case]] > type_opt, case, control), 
      levels = c(case, control)
    )
    
    return(
      c(
        caret::confusionMatrix(
          data = custom_pred,
          reference = real_labels,
          positive = case
        ),
        type_opt = type_opt
      )
    )
    
  }
  
  if (type_opt %in% c("misclasserror", "Both", "Ones", "Zeros")) {
    
    threshold <- InformationValue::optimalCutoff(
      actuals = ifelse(model$pred$obs == case, 1, 0),
      predictedScores = model$pred[[case]],
      optimiseFor = type_opt,
      returnDiagnostics = TRUE
    )
    
    custom_pred <- factor(
      x = ifelse(prob_preds[[case]] > threshold$optimalCutoff, case, control), 
      levels = c(case, control)
    )
    
    return(
      c(
        caret::confusionMatrix(
          data = custom_pred,
          reference = real_labels,
          positive = case
        ),
        type_opt = type_opt,
        threshold,
        tibble(id_observations = id_observations)
      )
    )
    
  }
  
}
