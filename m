Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B8F57F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 01:39:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C607AC006
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 23:39:18 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id T4NX4PlJApKIuTAw
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 23:39:14 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B10426C192
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 01:39:13 -0500 (CDT)
Message-ID: <51A05C96.1070101@hardwarefreak.com>
Date: Sat, 25 May 2013 01:39:18 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS assertion from truncate. (3.10-rc2)
References: <20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
	<20130524015219.GA28486@redhat.com>
	<20130524030300.GA30760@redhat.com>
	<20130524080300.GI24543@dastard> <51A044E5.1030105@sandeen.net>
In-Reply-To: <51A044E5.1030105@sandeen.net>
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
To: xfs@oss.sgi.com

On 5/24/2013 11:58 PM, Eric Sandeen wrote:
> On 5/24/13 3:03 AM, Dave Chinner wrote:
> 
>> Right, patch below should fix the problem.
>>
>> What a frustrating bug. Now, where's my bottle of scotch?
> 
> In your pantry, Dave.  Next to the others! ;)

Be careful with that stuff lest you have more bugs to fix. ;)

Heheh, how bout a T-Shirt:  "Don't drink and code" on the front, w/a
graphic of intoxicated Calvin tangled up in a wrecked PC on the back.
At least he won't be pissing on anything in this one. ;)

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
