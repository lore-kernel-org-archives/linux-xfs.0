Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EJdvt3120642 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:39:57 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5557A1B2ED42
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 12:39:56 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 0PP2JgYWfKs6BrQh for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2011 12:39:56 -0700 (PDT)
Message-ID: <4DF7B90C.8050100@sandeen.net>
Date: Tue, 14 Jun 2011 14:39:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests test case 229 fails consistently
References: <1308077636.7661.476.camel@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <1308077636.7661.476.camel@chandra-lucid.beaverton.ibm.com>
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
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 6/14/11 1:53 PM, Chandra Seetharaman wrote:
> Hello All,
> 
> xfstests test case 229 fails consistently in my x84_64 system.
> Only thing that is different between runs is the number of errors. 
> Any suggestions on how to proceed with the debug. 
> 
> regards,
> 
> chandra
> 

This one is known to fail.

http://oss.sgi.com/archives/xfs/2011-05/msg00237.html

"it's never passed. It's a placeholder to remind us how to
reproduce a known problem that is difficult to fix."

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
