Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 666187F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 16:58:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3405AC002
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 14:58:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jD5DUQkr4tyi8YtA for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 14:58:48 -0700 (PDT)
Message-ID: <5182E197.2030807@sandeen.net>
Date: Thu, 02 May 2013 16:58:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
	<1367516658.4098.87.camel@chandra-dt.ibm.com>
	<5182B0FE.4030301@sandeen.net> <5182CE0D.8030502@gmail.com>
	<5182D123.80005@redhat.com> <5182E09B.7070109@gmail.com>
In-Reply-To: <5182E09B.7070109@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, sekharan@us.ibm.com, xfs-oss <xfs@oss.sgi.com>

On 5/2/13 4:54 PM, Michael L. Semon wrote:

...

> So I'll consider this problem solved as well as another trial-by-fire lesson in using the device-mapper objects.  Thanks again!
> 
> Michael

well . . . it *should* work.  :(

Feel free to send patches to make it work.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
