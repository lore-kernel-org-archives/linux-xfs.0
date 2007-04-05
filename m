Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 01:30:35 -0700 (PDT)
Received: from ilsmtp.nds.com ([192.118.32.12])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l358UQfD013932
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 01:30:31 -0700
MIME-Version: 1.0
Subject: XFS Resiliency to the disk errors.
Date: Thu, 5 Apr 2007 11:08:07 +0300
Message-ID: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
From: "Zak, Semion" <SZak@nds.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,
 
We are studying possibility to use XFS with cheap (not too reliable)
discs, so we have some questions:
 
What in XFS is done to survive the disk errors (bad sectors)?
I know about superblock duplication in every AG. What else?
 
What is XFS behavior in case of the disk errors  (panic/no mount/partial
data access)?
 
What could be done to restore?
If  zero bad sector/dump to other device/format/restore will help? 
 
Thanks,
 
Semion.


[[HTML alternate version deleted]]
