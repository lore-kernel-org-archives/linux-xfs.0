Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71ED97F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 17:43:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D17730404E
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 15:43:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oArg2DtCT5rFBtTJ for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 15:43:42 -0700 (PDT)
Date: Mon, 27 May 2013 08:43:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130526224338.GL24543@dastard>
References: <20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
	<20130524015219.GA28486@redhat.com>
	<20130524030300.GA30760@redhat.com>
	<20130524080300.GI24543@dastard> <51A044E5.1030105@sandeen.net>
	<51A05C96.1070101@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A05C96.1070101@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sat, May 25, 2013 at 01:39:18AM -0500, Stan Hoeppner wrote:
> On 5/24/2013 11:58 PM, Eric Sandeen wrote:
> > On 5/24/13 3:03 AM, Dave Chinner wrote:
> > 
> >> Right, patch below should fix the problem.
> >>
> >> What a frustrating bug. Now, where's my bottle of scotch?
> > 
> > In your pantry, Dave.  Next to the others! ;)

Yeah, there's a few on the top shelf to choose from....

> Be careful with that stuff lest you have more bugs to fix. ;)

The secret is to wait till the next day before posting the patches.

> Heheh, how bout a T-Shirt:  "Don't drink and code" on the front,

Sorry, Stan, but you lost me at "Don't drink".... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
