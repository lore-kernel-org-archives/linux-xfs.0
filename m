Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7TMHBar246446 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 17:17:21 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A10C640D3C3
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:17:52 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id HgEmHggC2BbHATqA for
	<xfs@oss.sgi.com>; Sat, 29 Aug 2009 15:17:52 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 267926A1
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 00:17:22 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A550340015E
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 00:17:21 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: pushing out a new xfsprogs release,
	was Re: [PATCH] xfsprogs: fix unaligned access in libxfs
Date: Sun, 30 Aug 2009 00:17:07 +0200
References: <20090828153718.GA26409@infradead.org>
	<4A9810C7.8010806@sandeen.net>
	<20090828182454.GA8217@infradead.org>
In-Reply-To: <20090828182454.GA8217@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908300017.07268@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Freitag 28 August 2009 Christoph Hellwig wrote:
> What do people thing about pushing out a 3.0.3 xfsprogs
> release?

Is there the patch to repair my filesystem? I sent the metadump to Eric 
once, I think he did some patches. Are they there, or do I need 
something else also? I'm still having the problem, and would like to fix 
it.

mfg zmi
-- 
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
