Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E9737F37
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 00:56:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DC36304043
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 22:56:17 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yi9vJFlf2PICGZRb
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 22:56:16 -0800 (PST)
Message-ID: <5461B333.8050609@hardwarefreak.com>
Date: Tue, 11 Nov 2014 00:56:51 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Enforcing quota for root user
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
In-Reply-To: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
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
To: Cyril Scetbon <cyril.scetbon@free.fr>, xfs@oss.sgi.com



On 11/10/2014 04:46 PM, Cyril Scetbon wrote:
> Hi,
> 
> I'm trying to enforce quotas for the superuser without success. Can you
> tell me what I'm doing wrong ?

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch08s04.html

Look at the last line.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
