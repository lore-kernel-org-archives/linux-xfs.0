Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 791F87F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 02:03:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8AA3AC003
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 00:03:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tr7WiUtwzI3eX4Vb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2015 00:03:17 -0700 (PDT)
Date: Mon, 21 Sep 2015 09:03:12 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: What's up with this list?
Message-ID: <20150921070312.GA2617@redhat.com>
References: <alpine.LSU.2.11.1409181438290.6675@Telcontar.valinor>
	<541AFB60.5030403@sgi.com>
	<alpine.LSU.2.11.1509161436390.25528@minas-tirith.valinor>
	<55FAF053.3020405@sgi.com> <55FB06E8.1020203@opensuse.org>
	<55FC3569.5020801@sgi.com> <20150918225624.GF26895@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150918225624.GF26895@dastard>
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
Cc: Troy McCorkell <tdm@sgi.com>, carlos.e.r@opensuse.org, xfs@oss.sgi.com

On Sat, Sep 19, 2015 at 08:56:24AM +1000, Dave Chinner wrote:
> On Fri, Sep 18, 2015 at 11:01:45AM -0500, Troy McCorkell wrote:
> > xfs@oss.sgi.com is an open list and does not require people to be members
> > of the list to post to it.    The spam filters applied to
> > xfs@oss.sgi.com are
> > as aggressive as they can be and still allow for an open list.
> > 
> > Next option would be to add a moderator to the list.   Adding a moderator
> > would interfere with non-list members posting to the list.
> 
> Moderation is not an option because of this interference and the
> burden it puts on the moderator to respond in a timely fashion.
> 
> If the spam rejection does not improve our next option is to move to
> the linux-xfs@vger.kernel.org list - the vger infrastructure is not
> perfect, but it does have better spam rejection than the current
> filtering on this list.  This may be the best long-term solution to
> the problem, but it does involve short term pain for everyone.
> 

+1 for that, the pain is not that much, and we've discussed moving xfs list to
vger.kernel.org for a while, I really don't see a reason to do so, other than
people needing to update their e-mail addresses and maybe git configurations. To
relief even more the pain, xfs@sgi, could just forward the e-mails to linux-xfs
with a InReplyTo modified to linux-xfs even.

Althouh, I'm not sure how feasible is the last part.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
