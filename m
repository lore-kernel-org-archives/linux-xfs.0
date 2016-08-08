Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 327A57CA0
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 17:40:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F41898F8040
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 15:40:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mD1qOnxomW0Hr12O for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2016 15:40:14 -0700 (PDT)
Date: Tue, 9 Aug 2016 08:40:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
Message-ID: <20160808224011.GC19025@dastard>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
	<20160722040955.GB16413@zlang.usersys.redhat.com>
	<20160722085804.GA2990@redhat.com>
	<907731470.210439.1470653835697.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <907731470.210439.1470653835697.JavaMail.zimbra@redhat.com>
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
To: Carlos Eduardo Maiolino <cmaiolin@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 06:57:15AM -0400, Carlos Eduardo Maiolino wrote:
> Hi folks,
> 
> is there any update about this? I didn't see any comments if I need to change
> something on this patch to get the documentation applied, or perhaps I missed some e-mail?

I've been waiting for a v2.

i.e. If you have to explain how fail at unmount works (or doesn't,
in this case) during review, then that clearly needs to be added to
the documentation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
