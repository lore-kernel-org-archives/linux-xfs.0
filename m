Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7U8I9jn013213 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 03:18:21 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB19F1B83C14
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:18:27 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id hxDZPv7njesTaEc1 for
	<xfs@oss.sgi.com>; Sun, 30 Aug 2009 01:18:27 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id D9C143D1
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 10:17:51 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 6F87340015E
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 10:17:51 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs data loss
Date: Sun, 30 Aug 2009 10:17:31 +0200
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<B9A7B002C7FAFC469D4229539E909760308DA65408@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A99D4DF.50003@sandeen.net>
In-Reply-To: <4A99D4DF.50003@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908301017.31887@zmi.at>
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
> This all seems most likely to be a raid failure problem, but it's
> hard to know. =A0I can't imagine why you're getting
> suddenly-disappearing directories without a reboot or even a single
> error message; I just don't know what to make of that.

Exactly, what does "we had a power shock" mean? The OP said it was no =

power failure with reboot, so what happened?

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
