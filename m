Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OCeSKs079543 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 07:40:29 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 317E3120E9D5
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 05:49:19 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id DFMfobpO3GaMpA0d for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2009 05:49:19 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Date: Wed, 24 Jun 2009 14:40:52 +0200
References: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
In-Reply-To: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906241440.52272@zmi.at>
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
To: xfs@oss.sgi.com, Nitin Arora <nitin.arora.del@gmail.com>

On Mittwoch 24 Juni 2009 Nitin Arora wrote:
> I am using linux kernel 2.6.18 with XFS support.

If possible, can you simply try upgrading your ancient kernel to 
something newer? Actual is 2.6.30, with many many bugs fixed, not only 
in XFS.

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
