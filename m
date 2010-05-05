Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o45Fmo8I042650 for <xfs@oss.sgi.com>; Wed, 5 May 2010 10:48:51 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B3BB94443B
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 08:50:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3G3vav7Ko7FvhkXw for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 08:50:58 -0700 (PDT)
Message-ID: <4BE193AF.3070505@redhat.com>
Date: Wed, 05 May 2010 10:50:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] New testcase to check if fallocate
	respects	RLIMIT_FSIZE or not
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de>
	<201004291014.07194.knikanth@suse.de>
	<20100430143319.d51d6d77.akpm@linux-foundation.org>
	<20100501070426.GA9562@amitarora.in.ibm.com>
	<20100501101846.GA3769@infradead.org>
	<20100503083135.GC13756@amitarora.in.ibm.com>
	<4BE08718.5040608@redhat.com>
	<20100505075556.GA5142@amitarora.in.ibm.com>
In-Reply-To: <20100505075556.GA5142@amitarora.in.ibm.com>
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
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Andreas Dilger <adilger@sun.com>, Eelis <opensuse.org@contacts.eelis.net>, Theodore Ts'o <tytso@mit.edu>, Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de, Amit Arora <aarora@in.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

On 05/05/2010 02:55 AM, Amit K. Arora wrote:
> On Tue, May 04, 2010 at 03:44:08PM -0500, Eric Sandeen wrote:
>> Amit K. Arora wrote:
>>> Here is the new testcase.
>> Thanks!  A few comments...
> Thanks for the review!

Sure thing - looks good, I'll merge it after a retest if it all goes
well.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
