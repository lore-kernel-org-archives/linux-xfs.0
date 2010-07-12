Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CBir8Q025783 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 06:44:53 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5D1343CA03
	for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 04:47:46 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id S5uSmEo54Snzzhtm for
	<xfs@oss.sgi.com>; Mon, 12 Jul 2010 04:47:46 -0700 (PDT)
Date: Mon, 12 Jul 2010 13:47:43 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100712134743.624249b2@harpe.intellique.com>
In-Reply-To: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Le Sun, 11 Jul 2010 18:10:41 -0700
Eli Morris <ermorris@ucsc.edu> =E9crivait:

> Here are some of the log files from my XFS problem. Yes, I think this
> all started with a hardware failure of some sort. My storage is RAID
> 6, a an Astra SecureStor ES.
> =


There are IO errors on sdc, sdd and sdg. Aren't these jbods connected
through the same cable, for instance? You must correct the hardware
problems before attempting any repair or it will do more harm than good.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
