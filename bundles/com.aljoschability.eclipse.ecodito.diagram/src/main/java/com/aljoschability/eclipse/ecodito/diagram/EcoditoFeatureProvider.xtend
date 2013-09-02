package com.aljoschability.eclipse.ecodito.diagram

import com.aljoschability.eclipse.ecodito.diagram.features.EClassAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassLayoutFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassUpdateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeAddFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumAddFeature
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EObject
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IPictogramElementContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.ui.features.DefaultFeatureProvider

class EcoditoFeatureProvider extends DefaultFeatureProvider {
	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	def EObject bo(IPictogramElementContext context) {
		val bo = context.pictogramElement.businessObjectForPictogramElement
		if (bo instanceof EObject) {
			return bo
		}
	}

	override getAddFeature(IAddContext context) {
		switch context.newObject {
			EClass: new EClassAddFeature(this)
			EEnum: new EEnumAddFeature(this)
			EDataType: new EDataTypeAddFeature(this)
		}
	}

	override getUpdateFeature(IUpdateContext context) {
		switch context.bo {
			EClass: new EClassUpdateFeature(this)
			default: super.getUpdateFeature(context)
		}
	}

	override getLayoutFeature(ILayoutContext context) {
		switch context.bo {
			EClass: new EClassLayoutFeature(this)
			default: super.getLayoutFeature(context)
		}
	}
}
