Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 625427F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 18:28:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5175AC005
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 16:28:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5KYZepTyNqt33u1S for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 16:28:34 -0800 (PST)
Message-ID: <54767030.7070706@sandeen.net>
Date: Wed, 26 Nov 2014 18:28:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: no quota output if no usage?
References: <5476297F.8080304@sandeen.net>
	<20141126212144.GD9561@dastard>	<54764582.6000005@sandeen.net>
	<20141126221845.GE9561@dastard>
In-Reply-To: <20141126221845.GE9561@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/26/14 4:18 PM, Dave Chinner wrote:

>> Or am I missing something ...
> 
> Nope, I'm confusing different reporting command behaviour....

Ok, so back to the original question: think it's cool to drop
the verbose requirement to find out limits when there is 0 usage?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
