Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 08:37:55 -0700 (PDT)
Received: from chaos.egr.duke.edu (chaos.egr.duke.edu [152.3.195.82])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FFbm6p023745
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 08:37:49 -0700
Date: Thu, 15 Mar 2007 10:47:09 -0400 (EDT)
From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: XFS on Redhat4 U4
In-Reply-To: <4BE67D4A1485054E99B21710FF21A9CD020BE8A8@swsmsx411.ger.corp.intel.com>
Message-ID: <alpine.LRH.0.83.0703151043190.10425@chaos.egr.duke.edu>
References: <4BE67D4A1485054E99B21710FF21A9CD020BE8A8@swsmsx411.ger.corp.in
 tel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Carassale, Mario" <mario.carassale@intel.com>
Cc: xfs@oss.sgi.com

On Thu, 15 Mar 2007 at 2:30pm, Carassale, Mario wrote

> Is there any way to run XFS on RedHat 4 U4.
>
Centos (a RHEL rebuild distro) provides a kernel module RPM with updated 
(from that contained in the RHEL kernel source) XFS code.  See (e.g.):

http://mirror.centos.org/centos/4/centosplus/i386/RPMS/kernel-module-xfs-2.6.9-42.0.10.ELsmp-0.2-1.i686.rpm

(modify based on kernel version and architecture, obviously).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
