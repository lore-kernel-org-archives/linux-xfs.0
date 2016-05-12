Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 662437CA1
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 10:04:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA7ADAC003
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 08:04:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JNeP9KdiVglmAJtH for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 08:04:51 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8A1DC2537
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 10:04:51 -0500 (CDT)
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
	<20160512115513.GD32528@infradead.org>
	<20160512122039.GA19699@redhat.com>
	<20160512144726.GA5611@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <894f9680-a6f2-7c27-7c97-4bc45c3a320b@sandeen.net>
Date: Thu, 12 May 2016 10:04:50 -0500
MIME-Version: 1.0
In-Reply-To: <20160512144726.GA5611@infradead.org>
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
To: xfs@oss.sgi.com

On 5/12/16 9:47 AM, Christoph Hellwig wrote:
> On Thu, May 12, 2016 at 07:20:39AM -0500, Bill O'Donnell wrote:
>> xfs_multidisk.h came about a few days ago (4a32b9e928b80)
>> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> Gah, looks like I'm stuck on the oss.sgi.com repo..

We really need to kill that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
