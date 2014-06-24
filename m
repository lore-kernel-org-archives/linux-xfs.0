Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04B337F47
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 13:54:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A89898F8033
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:54:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id RF0qvSkA2Rz2e6Y2
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 11:54:56 -0700 (PDT)
Message-ID: <53A9C97F.2060908@hardwarefreak.com>
Date: Tue, 24 Jun 2014 13:54:55 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Repair hangs at inode repair in phase3
References: <trinity-a2065951-9261-435a-896b-4766fb281781-1403624615402@3capp-gmx-bs44>
In-Reply-To: <trinity-a2065951-9261-435a-896b-4766fb281781-1403624615402@3capp-gmx-bs44>
Reply-To: stan@hardwarefreak.com
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
To: Dragon <Sunghost@gmx.de>, xfs@oss.sgi.com

On 6/24/2014 10:43 AM, Dragon wrote:
> Hi,
> ok will try. So what could be the problem of this? Maybe the lost of one disk 
> out of raid6? I think not, or? Maybe a controller failure? Before i used ext4 
> and never had problems with this hardware...

If it's a hardware problem there should be errors in dmesg.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
