Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7U8i8S2014373 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 03:44:18 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E59EF1B83D22
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:44:54 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id P0eLkEcJZ1SGhWRW for
	<xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:44:54 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 9295C3D1
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 10:44:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5386940015E
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 10:44:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: pushing out a new xfsprogs release,
	was Re: [PATCH] xfsprogs: fix unaligned access in libxfs
Date: Sun, 30 Aug 2009 10:44:03 +0200
References: <20090828153718.GA26409@infradead.org> <200908300017.07268@zmi.at>
	<4A99D43D.5050208@sandeen.net>
In-Reply-To: <4A99D43D.5050208@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908301044.03807@zmi.at>
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
To: xfs@oss.sgi.com

On Sonntag 30 August 2009 Eric Sandeen wrote:
> Afraid I haven't fixed that one yet, sorry. =A0If you could open a bug
> on xfs.org's bugzilla it'd be much better for tracking ...

OK, looked there, but there are only 2 links: to kernel.org or =

oss.sgi.com bugzillas. Which one should I use?
BTW, wouldn't it be better to declare on the Wiki which bugzilla to use?

> I did find that building xfsprogs w/o debug ASSERTs turned on, I
> could get a clean fs after 2 runs, just to get you going again...

What would I need to take out exactly? Sorry, I don't know what "debug =

ASSERTs" are. I've seen from patches sent here those are commands, but =

which ones are for debug?

mfg zmi
-- =

// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
