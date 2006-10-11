Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 03:00:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9BA09aG012885
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 03:00:11 -0700
Date: Wed, 11 Oct 2006 19:59:14 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: LVM and XFS cannot set blocksize on block device
Message-ID: <2C085E259B9DC6D3BAB2BCB2@boing.melbourne.sgi.com>
In-Reply-To: <4526BE61.8020305@tulane.edu>
References: <45185424.2030707@tulane.edu>
 <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu>
 <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com>
 <452212CB.60103@sgi.com> <4526BE61.8020305@tulane.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <rsalmon@tulane.edu>
Cc: Shailendra Tripathi <stripathi@agami.com>, Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

Hi Rene,

--On 6 October 2006 3:36:49 PM -0500 Rene Salmon <rsalmon@tulane.edu> wrote:
> We are currently running SLES 10 on this box.  I have called IBM and they
> submitted a bug report to Novell and LTC Bugzilla 28003.
Ok.

>
> Is this all we need to do to get the patch into maybe SLES 10 SP1?
>
We will have an xfsprogs update (which will include this fix
amongst others) for sles10 sp1.

Cheers,
Tim.
