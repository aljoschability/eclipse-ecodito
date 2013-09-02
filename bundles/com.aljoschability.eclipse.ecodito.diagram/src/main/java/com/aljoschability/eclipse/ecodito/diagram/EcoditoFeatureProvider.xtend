package com.aljoschability.eclipse.ecodito.diagram

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import com.aljoschability.eclipse.ecodito.diagram.features.EClassAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumUpdateFeature
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.ui.features.DefaultFeatureProvider

class EcoditoFeatureProvider extends DefaultFeatureProvider {
	extension GraphitiExtensions = GraphitiExtensions::INSTANCE

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

	override getLayoutFeature(ILayoutContext context) {
		switch context.bo {
			EClass: new EClassLayoutFeature(this)
			EEnum: new EEnumLayoutFeature(this)
			EDataType: new EDataTypeLayoutFeature(this)
			default: super.getLayoutFeature(context)
		}
	}

	override getUpdateFeature(IUpdateContext context) {
		switch context.bo {
			EClass: new EClassUpdateFeature(this)
			EEnum: new EEnumUpdateFeature(this)
			EDataType: new EDataTypeUpdateFeature(this)
			default: super.getUpdateFeature(context)
		}
	}

}
