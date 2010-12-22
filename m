Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM9mesR211881 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 03:48:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9544D1CEA7E4
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 01:50:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	qUWvinAKlcHWWi87 for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 01:50:36 -0800 (PST)
Date: Wed, 22 Dec 2010 20:50:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs
Message-ID: <20101222095024.GI4907@dastard>
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
	<20101222060254.GH4907@dastard> <201012220904.56914@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201012220904.56914@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Eric Sandeen <sandeen@sandeen.net>, Amit Sahrawat <amit.sahrawat83@gmail.com>, xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 09:04:56AM +0100, Michael Monnerie wrote:
> On Mittwoch, 22. Dezember 2010 Dave Chinner wrote:
> > For future reference, when you are reporting a problem you need to
> > be specific about what you were doing to cause the problem you are
> > reporting.  Describe your kernel, your storage, your test case, any
> > errors that occurred before the problem you are reporting, etc.
> > 
> > We need this information to make any sense of your bug report, but
> > I'm getting tired of having to ask for it every time you report a
> > problem. The more information you put in your bug report, the more
> > likely we are to be able to help you. We don't have unlimited
> > amounts of time (or patience) to drag all the basic details of your
> > problem out of you over 3 or 4 emails, so including it up front will
> > help a lot....
> 
> Should I update this section?
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> We should probably just send that link to people so you don't have to 
> write long texts all the time.

Yup, I was looking at that earlier today and I agree that it needs
an update.  I'll update it to include everything that is generally
needed in the next few days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
