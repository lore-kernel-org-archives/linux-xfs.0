Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 13:49:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3NKnAih005626
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 13:49:13 -0700
Message-ID: <480FA0ED.90609@sandeen.net>
Date: Wed, 23 Apr 2008 15:49:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs 2.9.8 source tarball released
References: <op.t91vzgbk3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t91vzgbk3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.9.8-1.tar.gz
> 
> Changes since 2.9.7:
> 
>          - Add support for sb_features2 in wrong location in mkfs.xfs,
>            xfs_repair and xfs_db.
>          - Improve memory limits for libxfs cache in xfs_repair and added
>            a -m option to manually limit usage of xfs_repair.
>          - Add -c option to xfs_admin to turn lazy-counters on/off.
>          - Added support for mdp in libdisk/mkfs.xfs, thanks to
>            Hubert Verstraete.
>          - Add -p option to fsck.xfs, thanks to Markus Rothe.
>          - Cleanup sys v3 bzero/bcopy calls, thanks to Nigel Kukard.
> 
> 

This is in Fedora Rawhide now too, for anyone interested.

-Eric
