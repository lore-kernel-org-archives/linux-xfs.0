Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F35127F55
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8917304039
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:31:04 -0700 (PDT)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	uK2cqE6ECNDGs3V4 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:31:03 -0700 (PDT)
Received: by iecnq11 with SMTP id nq11so1400963iec.3
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:31:03 -0700 (PDT)
Message-ID: <55492883.5000705@gmail.com>
Date: Tue, 05 May 2015 16:30:59 -0400
From: nick <xerofoify@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/12] xfs:Make the function,xfs_alloc_lookup_eq static
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
	<20150505201837.GA11194@lst.de>
In-Reply-To: <20150505201837.GA11194@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On 2015-05-05 04:18 PM, Christoph Hellwig wrote:
> On Tue, May 05, 2015 at 04:16:28PM -0400, Nicholas Krause wrote:
>> This makes the function,xfs_alloc_lookup_eq static as there are no
>> calls to this function outside the definition file for this function,
>> xfs_alloc.c.
> 
> Nic, please stop trolling our lists.
> 
> Thank you, and *plonk*
> 
I am no trying to troll here, these are built tested and
apply fine for me.
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
