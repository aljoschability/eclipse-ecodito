package com.aljoschability.eclipse.ecodito.diagram;

import com.aljoschability.eclipse.core.graphiti.editors.CoreToolBehaviorProvider
import com.aljoschability.eclipse.ecodito.diagram.features.EAttributeCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLiteralCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EReferenceCreateFeature
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.palette.IPaletteCompartmentEntry
import org.eclipse.graphiti.palette.impl.PaletteCompartmentEntry
import org.eclipse.graphiti.palette.impl.PaletteSeparatorEntry

class EcoditoToolBehaviorProvider extends CoreToolBehaviorProvider {
	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	override getPalette() {
		val entries = newArrayList

		entries += createClassEntries
		entries += createTypesEntries

		return entries
	}

	def private IPaletteCompartmentEntry createClassEntries() {
		val entry = new PaletteCompartmentEntry("Classes", EcorePackage.Literals::ECLASS.name)

		entry.toolEntries += new EClassCreateFeature(featureProvider).creationTool

		entry.toolEntries += new PaletteSeparatorEntry

		entry.toolEntries += new EAttributeCreateFeature(featureProvider).creationTool
		entry.toolEntries += new EReferenceCreateFeature(featureProvider).creationTool

		entry.toolEntries += new PaletteSeparatorEntry

		entry.toolEntries += new EOperationCreateFeature(featureProvider).creationTool
		return entry
	}

	def private IPaletteCompartmentEntry createTypesEntries() {
		val entry = new PaletteCompartmentEntry("Types", EcorePackage.Literals::EDATA_TYPE.name)

		entry.toolEntries += new EDataTypeCreateFeature(featureProvider).creationTool

		entry.toolEntries += new PaletteSeparatorEntry

		entry.toolEntries += new EEnumCreateFeature(featureProvider).creationTool
		entry.toolEntries += new EEnumLiteralCreateFeature(featureProvider).creationTool

		return entry
	}
}
