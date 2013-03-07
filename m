Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB01E7F9B
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 14:16:21 -0600 (CST)
Date: Thu, 7 Mar 2013 14:16:17 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Fwd: xfs_reno
Message-ID: <20130307201617.GT22182@sgi.com>
References: <20351675.Zy117sIl8Z@xrated>
 <20130307041348.GD6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307041348.GD6369@dastard>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

Hi Pete,

On Thu, Mar 07, 2013 at 03:13:48PM +1100, Dave Chinner wrote:
> On Wed, Mar 06, 2013 at 03:55:19PM +0100, Hans-Peter Jansen wrote:
> > Hi Dave,
> > 
> > I tried to gather Barrys SOB, but failed so far. His trace ends in 2009 google 
> > wise.
> > 
> > How is this case usually handled?
> > 
> > Here's the current state of things.
> 
> He was working for SGI at the time, so you should be able to get
> anyone from SGI provide a valid S-O-B if needed.
> 
> As it is, I can probably verify the patch origins sufficiently
> to add a SOB to it as:
> 
> http://oss.sgi.com/archives/xfs/2007-11/msg00769.html
> 
> It's pretty clear that the code was released under the GPL and free
> from any tainted code by SGI. The post I'm pointing to above is one
> I made while an SGI employee, and it effectively verifies the origin
> of the code in the same way a S-O-B does.
> 
> So, you probably don't even need to chase a S-O-B from SGI if you
> just point at that email and attribute the code correctly. i.e.
> retaining al the SGI copyright notices in the code and saying inteh
> patch description that the code was originally authored by SGI and
> released under the same license as the rest of the xfs userspace
> code.

Looks good to me as is.  Links and attribution are in the header, copyright
notices, etc.  We'll clean up that copyright header in the Makefile with a
separate commit authored by a current SGI employee.

You can add a Signed-off-by: Ben Myers <bpm@sgi.com> if you want.  No need to
repost just for that.

Thanks for spending the time!

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
