package com.aljoschability.eclipse.ecodito.ui;

import org.eclipse.graphiti.dt.AbstractDiagramTypeProvider;
import org.eclipse.graphiti.features.IFeatureProvider;
import org.eclipse.graphiti.tb.IToolBehaviorProvider;

public class GrecotoDiagramTypeProvider extends AbstractDiagramTypeProvider {
	private GrecotoFeatureProvider featureProvider;
	private IToolBehaviorProvider[] toolBehaviourProviders;

	public GrecotoDiagramTypeProvider() {
		featureProvider = new GrecotoFeatureProvider(this);
		toolBehaviourProviders = new IToolBehaviorProvider[] { new GrecotoToolBehaviorProvider(this) };
	}

	@Override
	public IFeatureProvider getFeatureProvider() {
		return featureProvider;
	}

	@Override
	public IToolBehaviorProvider[] getAvailableToolBehaviorProviders() {
		return toolBehaviourProviders;
	}
}
