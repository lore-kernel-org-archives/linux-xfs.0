Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B85A7F51
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 09:03:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA813304053
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 07:03:20 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HhrUOCJAu7YmrFYh for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 07:03:17 -0800 (PST)
Message-ID: <5284E638.6070508@sandeen.net>
Date: Thu, 14 Nov 2013 09:03:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<52841AB9.9050906@sandeen.net>	<20131114064932.GO6188@dastard>
	<5284CB99.6030702@gmail.com>
In-Reply-To: <5284CB99.6030702@gmail.com>
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
To: Ric Wheeler <ricwheeler@gmail.com>, xfs@oss.sgi.com

On 11/14/13, 7:09 AM, Ric Wheeler wrote:
> I would agree that we should not to hit our 4K sector support, have
> we reached out the the KVM/QEMU people to see if we can get them to
> fix this on their side?

Yeah, talking to them now (well, not on a public list yet).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
