Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 16:33:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB80WxaG026986
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 16:33:01 -0800
Message-Id: <200612080010.LAA29025@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: QA regression test issues
Date: Fri, 8 Dec 2006 11:16:55 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1165536274.30459.51.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com, xfs@oss.sgi.com

Yes, xfs_repair has more progress information in recent versions. The
XFS QA tests are being updated with new xfs_repair filterings to filter
out that progress info as it's not required for QA.

I'll be doing further xfs_repair output cleanup at a later stage.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Nathan Scott
> Sent: Friday, 8 December 2006 11:05 AM
> To: xfs@oss.sgi.com
> Subject: QA regression test issues
> 
> Hi,
> 
> Is it just me or are many of the QA tests broken with current versions
> of xfs_repair?  In the "repair" check group, 3 out of 5 tests are not
> passing atm (with/without my last coupla patches).
> 
> Can the person who broke 'em, fix 'em please? :)  Thanks!
> 
> cheers.
> 
> -- 
> Nathan
> 
> 
