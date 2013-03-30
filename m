Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BB127F9C
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 15:21:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BC7F8F8040
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 13:21:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mhCO0ZLAmJgiTap9 for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 13:21:12 -0700 (PDT)
Message-ID: <5157493A.1040406@sandeen.net>
Date: Sat, 30 Mar 2013 15:21:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
	<5156DF72.1090703@hardwarefreak.com> <5157237A.40006@sandeen.net>
	<51573461.8070006@hardwarefreak.com>
In-Reply-To: <51573461.8070006@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/30/13 1:52 PM, Stan Hoeppner wrote:
> On 3/30/2013 12:40 PM, Eric Sandeen wrote:
>> On 3/30/13 7:49 AM, Stan Hoeppner wrote:
> 
>>> Ok, so here's the skinny on the source of our confusion WRT how/when
>>> EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
>>> the following.
>>
>> Where was this, out of curiosity?
> 
> Private email exchange with Ted.  I thought it was best from an
> etiquette standpoint not to wholesale paste his two private emails to
> the XFS list, but to summarize.  Maybe it would be ok if I put it on my
> web server for a couple of days then remove it.

I didn't need it verbatim, just wondered.  I agree, private emails
probably should stay that way, w/o permission otherwise.

Thanks,
-Eric

> http://www.hardwarefreak.com/ext4-journaling.txt
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
