Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 12:23:27 -0700 (PDT)
Received: from mx1.pretago.de (mx1.pretago.de [89.110.132.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OJNJ4p003667
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 12:23:21 -0700
From: Markus Schoder <lists@gammarayburst.de>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_RETURN
Date: Fri, 24 Aug 2007 20:23:17 +0100
References: <200708232109.50780.lists@gammarayburst.de> <46CE3C45.1080907@sgi.com>
In-Reply-To: <46CE3C45.1080907@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708242023.17327.lists@gammarayburst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Friday 24 August 2007, Timothy Shimmin wrote:
> It looks a lot like a reported bug:
>    Suse#198124 and sgi-pv#956334
>
> Where we had corruption in freespace btrees.
>
> Can you also run xfs_check before running xfs_repair.

I actually tried to run xfs_check before xfs_repair but it seg-faulted.

--
Markus
