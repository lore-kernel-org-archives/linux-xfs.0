Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D48A7F76
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 08:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26FBB304059
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 06:47:54 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id Ve4Zql3t07qX0NST for <xfs@oss.sgi.com>;
	Fri, 24 Jul 2015 06:47:49 -0700 (PDT)
Message-ID: <55B241FC.8020207@mygrande.net>
Date: Fri, 24 Jul 2015 08:47:40 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net> <20150719232754.GS7943@dastard>
	<55ACA615.10501@mygrande.net> <55B05CF5.8050204@sandeen.net>
In-Reply-To: <55B05CF5.8050204@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: Kris Rusocki <kszysiu@braxis.org>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/22/2015 10:18 PM, Eric Sandeen wrote:
> On 7/20/15 2:41 AM, Leslie Rhorer wrote:
>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>>>
>>>>      I found the problem with md5sum (and probably nfs, as well).  One
>>>> of the memory modules in the server was bad.  The problem with XFS
>>>> persists.  Every time tar tried to create the directory:
>>>
>>> Now you need to run xfs_repair.
>>
>> I do that every time the array implodes. It makes no difference. It
>> never mentions cleaning the structure tar says needs cleaning, and
>> the next time I run tar on that file, the filesystem craters.
>>
>
> What.
> Did.
> xfs_repair.
> Say.

Look.
At.
My.
First.
E-mail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
