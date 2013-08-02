Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56DA87F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 15:40:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47ADE8F8040
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 13:40:30 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id 0kSX5Xos2DZdZkyN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 13:40:29 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 16:40:28 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3ABA9C90044
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:40:23 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72KeOK2181016 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 16:40:24 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r72KeNmg027005 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 17:40:24 -0300
Subject: Re: [PATCH 0/2] xfsprogs: Allow pquota and gquota to be used together
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130802015032.GY7118@dastard>
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
	<20130802015032.GY7118@dastard>
Date: Fri, 02 Aug 2013 15:40:19 -0500
Message-ID: <1375476019.4155.66.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2013-08-02 at 11:50 +1000, Dave Chinner wrote:
> On Thu, Aug 01, 2013 at 02:24:59PM -0500, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > These two patches make the relevant user space changes to support
> > the gquota/pquota in kernel.
> > 
> > It applies cleanly on crc-dev branch of xfsprogs.
> 
> I think I've already brought all of the libxfs pquota changes across
> in the series of patches I have that unified the kernel and
> userspace code on top of the crc-dev branch....

Cool.

I just looked at your patches. Some of my changes are still not in those
patches.

I will rebase and post a new patchset once your patches are merged in.

Thanks

Chandra
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
