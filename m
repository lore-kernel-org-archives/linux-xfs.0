Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EDA057CA6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 03:11:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0EBF304051
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 01:11:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BjY4BbGAqtsX7Iul (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 01:11:50 -0700 (PDT)
Date: Tue, 9 Aug 2016 04:11:47 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Document error handling behavior
Message-ID: <20160809081147.GA64251@redhat.com>
References: <1468922657-3895-1-git-send-email-cmaiolino@redhat.com>
	<20160722040955.GB16413@zlang.usersys.redhat.com>
	<20160722085804.GA2990@redhat.com>
	<907731470.210439.1470653835697.JavaMail.zimbra@redhat.com>
	<20160808224011.GC19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160808224011.GC19025@dastard>
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

On Tue, Aug 09, 2016 at 08:40:11AM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2016 at 06:57:15AM -0400, Carlos Eduardo Maiolino wrote:
> > Hi folks,
> > 
> > is there any update about this? I didn't see any comments if I need to change
> > something on this patch to get the documentation applied, or perhaps I missed some e-mail?
> 
> I've been waiting for a v2.
> 
> i.e. If you have to explain how fail at unmount works (or doesn't,
> in this case) during review, then that clearly needs to be added to
> the documentation.

Well, can't argue with that, I'll rework it and send a V2 :)


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
