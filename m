Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LGqSHV142627 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 11:52:28 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00FC6143A020
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 09:55:05 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id 2IRxL8BWD60vXM2y for
	<xfs@oss.sgi.com>; Tue, 21 Apr 2009 09:55:05 -0700 (PDT)
Date: Tue, 21 Apr 2009 12:52:18 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Message-ID: <20090421165218.GX3709@josefsipek.net>
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
	<20090418050544.GQ3709@josefsipek.net>
	<81FBAD0F-AE2A-4780-BC8B-135C4CCE8D3A@sgi.com>
	<20090419181410.GS3709@josefsipek.net>
	<3296B35F-1364-4E7B-856B-041AF746BFFC@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3296B35F-1364-4E7B-856B-041AF746BFFC@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 21, 2009 at 10:47:30AM -0500, Felix Blyakher wrote:
...
>> This makes me believe that the author
>> should include a s-o-b line as well.
>>
>> So, for example, whenever _I_ send a patch that I authored, I have  
>> both a From and a s-o-b.
>
> That seems redundant based on the following excerpt from the
> SubmittingPatches:
>
> If the "from" line is missing,
> then the "From:" line from the email header will be used to determine
> the patch author in the changelog.

If you look at the "sign your work" section in that doc, the example it
provides shows the original patch author having a s-o-b as well. ;)

Anyway, enough of this...time to hack on xfs some more :)

Jeff.

-- 
*NOTE: This message is ROT-13 encrypted twice for extra protection*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
