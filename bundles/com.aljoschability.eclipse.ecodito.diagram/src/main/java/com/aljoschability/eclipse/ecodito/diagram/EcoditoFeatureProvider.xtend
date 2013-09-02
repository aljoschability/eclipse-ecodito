package com.aljoschability.eclipse.ecodito.diagram

import com.aljoschability.eclipse.ecodito.diagram.features.EClassAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumAddFeature
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.ui.features.DefaultFeatureProvider

class EcoditoFeatureProvider extends DefaultFeatureProvider {
	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	override getAddFeature(IAddContext context) {
		switch context.newObject {
			EClass: new EClassAddFeature(this)
			EEnum: new EEnumAddFeature(this)
			EDataType: new EDataTypeAddFeature(this)
		}
	}
}
