Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B748F7F6F
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 13:52:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54540AC003
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 11:52:19 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id IV4zMO4pfCN3O1rl
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 11:52:18 -0700 (PDT)
Message-ID: <51573461.8070006@hardwarefreak.com>
Date: Sat, 30 Mar 2013 13:52:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
	<5156DF72.1090703@hardwarefreak.com> <5157237A.40006@sandeen.net>
In-Reply-To: <5157237A.40006@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/30/2013 12:40 PM, Eric Sandeen wrote:
> On 3/30/13 7:49 AM, Stan Hoeppner wrote:

>> Ok, so here's the skinny on the source of our confusion WRT how/when
>> EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
>> the following.
> 
> Where was this, out of curiosity?

Private email exchange with Ted.  I thought it was best from an
etiquette standpoint not to wholesale paste his two private emails to
the XFS list, but to summarize.  Maybe it would be ok if I put it on my
web server for a couple of days then remove it.

http://www.hardwarefreak.com/ext4-journaling.txt

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
