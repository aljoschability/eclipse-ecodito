package com.aljoschability.eclipse.ecodito.ui;

import org.eclipse.graphiti.dt.IDiagramTypeProvider;
import org.eclipse.graphiti.pattern.DefaultFeatureProviderWithPatterns;

import com.aljoschability.eclipse.ecodito.ui.patterns.EAttributePattern;
import com.aljoschability.eclipse.ecodito.ui.patterns.EClassPattern;
import com.aljoschability.eclipse.ecodito.ui.patterns.EDataTypePattern;
import com.aljoschability.eclipse.ecodito.ui.patterns.EEnumPattern;
import com.aljoschability.eclipse.ecodito.ui.patterns.EOperationPattern;

public class GrecotoFeatureProvider extends DefaultFeatureProviderWithPatterns {
	public GrecotoFeatureProvider(IDiagramTypeProvider dtp) {
		super(dtp);

		addPattern(new EClassPattern(null));

		addPattern(new EAttributePattern(null));
		addPattern(new EOperationPattern(null));

		addPattern(new EDataTypePattern(null));

		addPattern(new EEnumPattern(null));
		// addPattern(new EEnumLiteralPattern(null));
	}
}
