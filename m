Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Aug 2006 17:33:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7E0WVDW011290
	for <xfs@oss.sgi.com>; Sun, 13 Aug 2006 17:32:42 -0700
Date: Mon, 14 Aug 2006 10:31:39 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: File problem question
Message-ID: <20060814103139.B2698880@wobbly.melbourne.sgi.com>
References: <44DC44FA.4060401@rentalia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44DC44FA.4060401@rentalia.com>; from ruben@rentalia.com on Fri, Aug 11, 2006 at 10:51:06AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Rubio <ruben@rentalia.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 11, 2006 at 10:51:06AM +0200, Ruben Rubio wrote:
> root@rigodon log # pwd
> /var/log
> root@rigodon log # ls -al lastlog
> - -r--------  1 root root 146292 ago 11 10:44 lastlog
> root@rigodon log # du -sh * | grep lastlog
> 7,6G    lastlog

what does "xfs_bmap -vp lastlog" say?

cheers.

-- 
Nathan
