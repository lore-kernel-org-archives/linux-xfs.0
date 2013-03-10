Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AE1F7F53
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 19:10:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B221304032
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 17:10:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IC9nUFn0euw3UrGH for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 17:10:06 -0800 (PST)
Message-ID: <513BDD6E.7010507@sandeen.net>
Date: Sat, 09 Mar 2013 19:10:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Maximum file system size of XFS?
References: <20130309215121.0e614ef8@thinky> <513BB7C3.4050009@redhat.com>
	<20130309233940.3b7c0910@thinky>
In-Reply-To: <20130309233940.3b7c0910@thinky>
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
To: Pascal <pa5ca1@gmx.de>
Cc: xfs@oss.sgi.com

On 3/9/13 4:39 PM, Pascal wrote:

> Hello Ric,
> 
> thank you for your answer. I am aware that there is a difference
> between the maximum size under practical conditions and the theoretical
> maximum. But I am looking for this theoretical number to use in within
> in my thesis comparing file systems.

A thesis comparing actual scalability would be much more interesting
than one comparing, essentially, the container size chosen for a disk
block.  One could quickly write a filesystem which "can" be as large
as a yottabyte, but it wouldn't really *mean* anything.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
