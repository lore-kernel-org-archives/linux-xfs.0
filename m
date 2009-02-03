Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n139PYDm050530 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 03:25:34 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09ED7DE071
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 01:24:54 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id F6WOTSJ8lb8eW4Nc for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 01:24:54 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 0A4D73CB8
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 10:24:54 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id CD58040016F
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 10:24:53 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [Fwd: Bug#513821: xfsprogs: xfs_growfs does not work]
Date: Tue, 3 Feb 2009 10:24:53 +0100
References: <1233641256.5518.83.camel@verge.scott.net.au>
	<1233641336.5518.85.camel@verge.scott.net.au>
	<20090203062036.GA23098@infradead.org>
In-Reply-To: <20090203062036.GA23098@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902031024.53548@zmi.at>
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

On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> > and "Kernel: Linux 2.6.26-1-amd64 (SMP w/1 CPU core)" to save ya
> > looking.
>
> 2.6.16 didn't have the compat ioctl handler for growfs yet, and this
> is i386 xfsprogs on a 64bit kernel. =A0He needs to upgrade to a more
> recent kernel.

He wrote 2.6.26....

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
