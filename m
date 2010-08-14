Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7E5LFcL132384 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 00:21:15 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18EC9170C8AD
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 22:21:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Ob5LpKfEQDgZZtCU
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 22:21:41 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 68A9F6C307
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 00:21:41 -0500 (CDT)
Message-ID: <4C6627E4.3040000@hardwarefreak.com>
Date: Sat, 14 Aug 2010 00:21:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Message to Stan Hoeppner
References: <201008131300.40536@zmi.at>
In-Reply-To: <201008131300.40536@zmi.at>
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

Michael Monnerie put forth on 8/13/2010 6:00 AM:
> Dear Stan,
> 
> <stan@hardwarefreak.com>: host greer.hardwarefreak.com[65.41.216.221] 
> said: 550    5.7.1 <mailsrv1.zmi.at[212.69.164.54]>: Client host 
> rejected: We do not accept mail from .at domains (in reply to RCPT TO 
> command)
> 
> I don't know what experiences you've had, but Austria is not that bad. 
> We have Mozart, Walzer, the Danube, and Vienna is worlds most beautiful 
> city to live in (search "vienna best city in the world" on Google finds 
> http://www.citymayors.com/features/quality_survey.html and others).
> 
> Maybe you could rethink that policy? Spam rate is quite low with .at 
> domains, compared to others.

Fixed.  Sorry about that Michael.  I had an old pcre that checked the SMTP
client rDNS host name against a bunch of ccTLDs I received spam from some time
ago.  I forgot to disable it when I moved to a much more effective and a bit
more sane anti-spam configuration.  I'm surprised someone such as yourself
hadn't tripped this before now with all the lists I subscribe to.

That said, I do still block some entire countries' IP space using ipdeny.com
info, such as China, Russia, Korea, Malaysia, and a handful of others from
which I'll likely never receive legit mail.  I might from Russia due to some
of my list memberships.

The "Reply-to-list" option in one's MUA is one's friend.  Reply-all causes
rows like this and just duplicates messages needlessly.  There are times when
a reply-all is needed, but usually that's not the case.  Only when non-list
members are CC'd in a thread do I hit the "reply-all" button.

Anyway, enough about mail management and my somewhat draconian anti-spam
policies. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
