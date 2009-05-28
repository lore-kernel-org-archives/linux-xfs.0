Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SFI7PG260429 for <xfs@oss.sgi.com>; Thu, 28 May 2009 10:18:07 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF1A4FAED96
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:24:22 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HCghAb3XqD56FehL for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 08:24:22 -0700 (PDT)
Message-ID: <4A1EAB31.7090604@sandeen.net>
Date: Thu, 28 May 2009 10:18:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: regarding the inode64 mount option
References: <4A1E81D8.7010706@dermichi.com>
	<20090528145612.GA14684@infradead.org>
In-Reply-To: <20090528145612.GA14684@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Weissenbacher <mw@dermichi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, May 28, 2009 at 02:21:44PM +0200, Michael Weissenbacher
...

>> I haven't found any definitive clear documentation abount the pro's
>> and con's, so maybe you can give me some hints :-)
> 
> The only reason speaking against inode64 are old buggy programs that 
> can't cope with a 64bit ino_t, Eric had a quite scary list of those 
> in Fedora somewhere..

http://sandeen.net/wordpress/?p=9
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
