Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3UHSgZW233417 for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 12:28:43 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FA0B14638BB
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 10:32:11 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id FxbN8nUKxhR3wgEe for
	<xfs@oss.sgi.com>; Thu, 30 Apr 2009 10:32:11 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217107103.dyn.cm.kabsi.at
	[81.217.107.103])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id A661653F2
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 19:28:39 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 260F940017B
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 19:28:39 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: EXT vs XFS at 80% filled filesystem
Date: Thu, 30 Apr 2009 19:28:38 +0200
References: <49F9565E.40804@gslab.com>
In-Reply-To: <49F9565E.40804@gslab.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904301928.38873@zmi.at>
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

On Donnerstag 30 April 2009 Milind Dumbare wrote:
> I have heard of XFS's performance is not good as compared to EXT3
> when the filesystem(disk) is 80% filled with data. Is it true? I have
> went through lots of performance documents of both XFS and EXT3 but
> could not find such performance benchmarking (for 80% full
> filesystems).
>
> Any numbers or pointers to other documents are appreciated.

Never heard that before. Where did you hear this?

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
