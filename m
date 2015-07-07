Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CC7C7F50
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 19:19:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 459078F8054
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 17:19:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y6JScHNyEcZ2Jj7b for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 17:19:49 -0700 (PDT)
Date: Tue, 7 Jul 2015 10:19:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150707001900.GU7943@dastard>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
	<20150703235500.GR7943@dastard>
	<0F9CF77D-1DA5-41DD-87AA-7F4109F08EFB@intomics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0F9CF77D-1DA5-41DD-87AA-7F4109F08EFB@intomics.com>
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
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 06, 2015 at 01:08:52PM +0200, Rasmus Borup Hansen wrote:
> I've made a metadump and I'm running another xfs_repair, but given
> that the first metadump is 132 GB, will you still be interested in
> looking at the dumps?

That's significantly larger than my monthly download quota.  How big
is it once you compress it?

Also, because of the size of the metadump, I'll need some context
about the hardware it is running on. Can you you please also provide
the information in:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

so I have a better idea of environment the problem is showing up in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
