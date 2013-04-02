Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 812627F8E
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 15:55:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58983304032
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 13:55:38 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id fMUEUfjJMkut1jaU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 13:55:36 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.hs.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r32KtVd8008851 for <xfs@oss.sgi.com>; Tue, 2 Apr 2013 13:55:34 -0700
Message-ID: <515B45C2.50203@tlinx.org>
Date: Tue, 02 Apr 2013 13:55:30 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: General Question... I note many emails about BTRFS ... is it
	related to XFS?
References: <515B3F45.8070504@tlinx.org> <20130402203458.GY22182@sgi.com>
	<515B4188.90205@redhat.com>
In-Reply-To: <515B4188.90205@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>



Ric Wheeler wrote:
> On 04/02/2013 04:34 PM, Ben Myers wrote:
>> Hey Linda,
>>
>> On Tue, Apr 02, 2013 at 01:27:49PM -0700, Linda Walsh wrote:
>>> I have no issues with the messages related to BTRFS on the list, but it
>>> did stimulate my curiosity -- what's the relationship betweeen BTRFS
>>> and XFS?
>>>
>>> * Just using a similar test suite?
>> We're all sharing the test suite.  ;)
----
	Excellent way to leverage a huge body of existing work...

	I'm sure it will flush out more errors in XFS as well,
especially in the more BTRFS specific tests... XFS will just
have to add some more features to fully pass the test suite... ;-)



	BtB, having BTRFS pass the XFS test suite would certainly
make me more confident about trying it out and using it for production
work...but I suppose that's part of the intent!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
