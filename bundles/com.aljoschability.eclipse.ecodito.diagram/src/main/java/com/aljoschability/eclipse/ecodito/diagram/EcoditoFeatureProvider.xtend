package com.aljoschability.eclipse.ecodito.diagram;

import com.aljoschability.eclipse.ecodito.diagram.features.EAttributePattern
import com.aljoschability.eclipse.ecodito.diagram.features.EClassPattern
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypePattern
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumPattern
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationPattern
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.pattern.DefaultFeatureProviderWithPatterns

class EcoditoFeatureProvider extends DefaultFeatureProviderWithPatterns {
	new(IDiagramTypeProvider dtp) {
		super(dtp);

		addPattern(new EClassPattern(null));

		addPattern(new EAttributePattern(null));
		addPattern(new EOperationPattern(null));

		addPattern(new EDataTypePattern(null));

		addPattern(new EEnumPattern(null));

	// addPattern(new EEnumLiteralPattern(null));
	}
}
