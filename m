Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC7187F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 07:54:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72259304059
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 05:54:06 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	fSikMOCDvU9rBbUo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 05:54:00 -0700 (PDT)
Received: by wicfx3 with SMTP id fx3so71592151wic.1
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 05:53:59 -0700 (PDT)
Received: from minas-tirith.valinor (3.Red-83-42-78.dynamicIP.rima-tde.net.
	[83.42.78.3]) by smtp.gmail.com with ESMTPSA id
	mc18sm4357358wic.23.2015.09.16.05.53.58 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 16 Sep 2015 05:53:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id D0F8118286E
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 14:53:56 +0200 (CEST)
Date: Wed, 16 Sep 2015 14:53:56 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: What's up with this list?
In-Reply-To: <541AFB60.5030403@sgi.com>
Message-ID: <alpine.LSU.2.11.1509161436390.25528@minas-tirith.valinor>
References: <alpine.LSU.2.11.1409181438290.6675@Telcontar.valinor>
	<541AFB60.5030403@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-2002901569-1442407685=:25528"
Content-ID: <alpine.LSU.2.11.1509161452080.25528@minas-tirith.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-2002901569-1442407685=:25528
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1509161452081.25528@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1509161452080.25528@minas-tirith.valinor>


El 2014-09-18 a las 10:33 -0500, Troy McCorkell escribió:
> On 09/18/2014 07:46 AM, Carlos E. R. wrote:
>
>       Hi,
>
>       Now an then I get messages like this:
>
>       ++·································
>       Your membership in the mailing list xfs has been disabled due to
>       excessive bounces The last bounce received from you was dated
>       18-Sep-2014.  You will not get any more messages from this list until
>       you re-enable your membership.  You will receive 3 more reminders like
>       this before your membership in the list is deleted.
>
>       To re-enable your membership, you can simply respond to this message
>       (leaving the Subject: line intact), or visit the confirmation page at
>
>       ...
>
>       ·································++-
> 
>
>       Bounces? I'm subscribed to several mail lists, and this is the only one "complaining". And as I do not know
>       what messages bounced, I can not investigate it.
>
>       My guess is that those emails were clear and flagrant spam, and as such were rejected by my ISP.
>
>       The mail list should refuse them on entry and not resend them to the listers.
>
>       - -- Cheers,
>              Carlos E. R.
>              (from 13.1 x86_64 "Bottle" at Telcontar)
> 
> Carlos,
> 
> I will forward your email to the SGI IT group.

Well, I got no further feedback, and the issue continues, a year later.

As I see it, it goes like this:

Spam is sent to the list. The list forwards it to subscribers. Some mail 
servers, like my ISP, point blank refuse to accept what is flagrant spam; 
not a doubt about it, it doesn't reach the spam folder. That spam probably 
breaks a rule such as having no valid sender domain, breaking SPF, 
something. I don't know for sure, because I can not see the logs of my 
ISP. But the oss.sgi.com admin can, surely.


The problem for me is that this list server automatically unsubscribes me, 
and I have to re-subscribe, posibly loosing interveening posts.


I suggest that the list server implements filters to remove those spam 
mails on entry, instead of forwarding them. Alternatively, other mail list 
servers send a probe email to the subscriber; if the probe bounces, twice, 
then the subscription is temporarily disabled. But they don't unsubscribe 
people because some "list" posts bounce, unless it is excesive.


- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlX5ZmQACgkQja8UbcUWM1wcxQD7BUPP7V8jRho3G3H0Oz/ZqVVs
APLSE6oLIsGW/4GYn54A/0RiNx3Nd5gLhW8hYv6ljyNLqH26aUzYdiw3YO7c3mbb
=oF/M
-----END PGP SIGNATURE-----
---1463779071-2002901569-1442407685=:25528
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-2002901569-1442407685=:25528--
