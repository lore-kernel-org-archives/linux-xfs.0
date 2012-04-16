Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GAIto2197476 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 05:18:55 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 76fK0AZT3FxqIvD0
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 03:18:54 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BC9626C0B5
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 05:18:54 -0500 (CDT)
Message-ID: <4F8BF20D.9080205@hardwarefreak.com>
Date: Mon, 16 Apr 2012 05:18:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_check segfault / xfs_repair I/O error
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
	<20120415223106.GU6734@dastard>
In-Reply-To: <20120415223106.GU6734@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/15/2012 5:31 PM, Dave Chinner wrote:
> On Sun, Apr 15, 2012 at 11:15:09PM +1000, Drew Wareham wrote:

>>     cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK CONDITION sense
>> key = 0x3
> 
> This is clearly a raid array error....

https://bugzilla.redhat.com/show_bug.cgi?id=722780
http://h30499.www3.hp.com/t5/ProLiant-Servers-ML-DL-SL/DL180-G5-showing-hard-drive-error-messages/td-p/4771517
http://h30499.www3.hp.com/t5/General/i-o-error-linux-DL380G5/td-p/4772829

Not sure if these are relevant Drew but I'm posting them just in case.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
