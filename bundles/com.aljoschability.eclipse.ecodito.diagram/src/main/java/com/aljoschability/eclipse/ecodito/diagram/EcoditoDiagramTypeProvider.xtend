package com.aljoschability.eclipse.ecodito.diagram;

import org.eclipse.graphiti.dt.AbstractDiagramTypeProvider
import org.eclipse.graphiti.tb.IToolBehaviorProvider

class EcoditoDiagramTypeProvider extends AbstractDiagramTypeProvider {
	EcoditoFeatureProvider featureProvider;
	IToolBehaviorProvider[] toolBehaviourProviders;

	new() {
		featureProvider = new EcoditoFeatureProvider(this);
		toolBehaviourProviders = #[new EcoditoToolBehaviorProvider(this)]
	}

	override getFeatureProvider() {
		return featureProvider;
	}

	override getAvailableToolBehaviorProviders() {
		return toolBehaviourProviders;
	}
}
